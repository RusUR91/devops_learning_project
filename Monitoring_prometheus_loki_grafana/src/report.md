
# DO9_Monitoring
## Part 1. Получение метрик и логов

1.Использовать Docker Swarm из первого проекта.


2.Написать при помощи библиотеки Micrometer сборщики следующих метрик приложения.

Довляем необходимые модули в:
- services/booking-service/pom.xml
- services/report-service/pom.xml
- services/gateway-service/pom.xml
- services/session-service/pom.xml

Actuator — предоставляет готовые эндпоинты для получения информации о работающем приложении.

Micrometer — необходим для сбора метрик, в данном случае добавляет поддержку Prometheus.

```
<!-- Spring Boot Actuator for monitoring -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>

<!-- Micrometer Prometheus registry -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```
Далее добавляем необходимые конфиги в:

- services/booking-service/src/main/resources/application.properties
- services/report-service/src/main/resources/application.properties
- services/gateway-service/src/main/resources/application.properties
- services/session-service/src/main/resources/application.properties

```
# Actuator configuration
management.endpoints.web.exposure.include=health,info,metrics,prometheus
management.endpoint.health.show-details=always

# Micrometer configuration
management.metrics.export.prometheus.enabled=true
management.metrics.distribution.percentiles-histogram.http.server.requests=true

# Add common tags for Prometheus
management.metrics.tags.application= ...
management.metrics.tags.environment=production
```
Actuator configuration - открывает доступ к эндпоинтам.

Micrometer configuration - экспорт метрик для Prometheus.

Add common tags for Prometheus - добавляет теги к метрикам приложения.


### - Количество отправленных сообщений в rabbitmq:

Добавляем в services/booking-service/src/main/java/com/s21/devops/sample/bookingservice/Statistics/QueueProducer.java
```
// импорты для Micrometer
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import javax.annotation.PostConstruct;

@Component
public class QueueProducer {
    @Value("${fanout.exchange}")
    private String fanoutExchange;

    @Autowired
    private RabbitTemplate rabbitTemplate;

    private ObjectMapper objectMapper = new ObjectMapper();

    // Добавляем MeterRegistry
    @Autowired
    private MeterRegistry meterRegistry;

    // Счётчик
    private Counter sentMessagesCounter;

    // Инициализация счётчика после создания
    @PostConstruct
    public void init() {
        sentMessagesCounter = Counter.builder("rabbitmq.sent.messages")
                .description("Total number of messages sent to RabbitMQ")
                .tag("service", "booking-service")
                .register(meterRegistry);
    }

    public void putStatistics(BookingStatisticsMessage bookingStatisticsMessage) throws JsonProcessingException {
        System.out.println("Sending message...");
        rabbitTemplate.setExchange(fanoutExchange);
        rabbitTemplate.convertAndSend(objectMapper.writeValueAsString(bookingStatisticsMessage));
        System.out.println("Message was sent successfully!");

        // Увеличиваем счётчик после успешной отправки
        sentMessagesCounter.increment();
    }
}
```
### - Количество обработанных сообщений в rabbitmq:

Добавляем в services/report-service/src/main/java/com/s21/devops/sample/reportservice/Statistics/QueueConsumer.java
```
// импорты для Micrometer
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import javax.annotation.PostConstruct;

@Component
public class QueueConsumer {
    @Autowired
    private BookingStatsService bookingStatsService;

    private ObjectMapper objectMapper = new ObjectMapper();

    // --- Добавлено для метрик ---
    @Autowired
    private MeterRegistry meterRegistry;

    private Counter processedMessagesCounter;

    @PostConstruct
    public void init() {
        processedMessagesCounter = Counter.builder("rabbitmq.processed.messages")
                .description("Total number of messages processed from RabbitMQ")
                .tag("service", "report-service")
                .register(meterRegistry);
    }

    public void receiveMessage(String message) throws JsonProcessingException {
        System.out.println("Received !!! (String) " + message);
        processMessage(message);
    }

    public void receiveMessage(byte[] message) throws JsonProcessingException {
        String strMessage = new String(message);
        System.out.println("Received !!! (No String) " + strMessage);
        processMessage(strMessage);
    }

    private void processMessage(String message) throws JsonProcessingException {
        BookingStatisticsMessage bsm = objectMapper.readValue(message, BookingStatisticsMessage.class);
        bookingStatsService.postBookingStatsMessage(bsm);
        // Увеличиваем счётчик после успешной обработки
        processedMessagesCounter.increment();
    }
}
```

### - Количество бронирований:

Добавляем в services/booking-service/src/main/java/com/s21/devops/sample/bookingservice/Service/BookingServiceImplementation.java
```
// импорты для Micrometer
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import javax.annotation.PostConstruct;

---

@Autowired
private MeterRegistry meterRegistry;

private Counter bookingsCounter;

@PostConstruct
public void initMetrics() {
    bookingsCounter = Counter.builder("bookings.total")
            .description("Total number of bookings created")
            .tag("service", "booking-service")
            .register(meterRegistry);
}

---

try {
    reservationRepository.save(reservation);
    // Увеличиваем счётчик бронирования после успешного сохранения ---
    bookingsCounter.increment();
} catch (Exception ex) {
    fallbackPay(paymentUids, bookingStatisticsMessages);
    throw new ReservationAlreadyExistsException("Reservation for date " + current.toString() + " already exists!");
}
```

### - Количество полученных запросов на gateway:

Добавляем в services/gateway-service/src/main/java/com/s21/devops/sample/gatewayservice/Controller/GatewayController.java
```
// --- Добавлено для метрик ---
@Autowired
private MeterRegistry meterRegistry;

private Counter gatewayRequestsCounter;

@PostConstruct
public void init() {
    gatewayRequestsCounter = Counter.builder("gateway.requests.total")
            .description("Total number of requests to gateway")
            .tag("service", "gateway-service")
            .register(meterRegistry);
}

---

@PostMapping("/users")
public void createUser(@Valid @RequestBody CreateUserReq createUserReq, @RequestHeader("Authorization") String authorization)
        throws UserAlreadyExistsException {
    gatewayRequestsCounter.increment();     // <-- счётчик
    sessionService.createUser(createUserReq, authorization);
}

@GetMapping("/hotels")
public HotelInfoRes[] getHotels()
        throws CustomJwtException, CustomRuntimeException {
    gatewayRequestsCounter.increment();     // <-- счётчик
    return hotelsService.getAllHotels();
}
```
### - Количество полученных запросов на авторизацию пользователей:

Добавляем в services/session-service/src/main/java/com/s21/devops/sample/sessionservice/Controller/SessionController.java 
```
@Autowired
private MeterRegistry meterRegistry;

private Counter authRequestsCounter;

@PostConstruct
public void init() {
    authRequestsCounter = Counter.builder("auth.requests.total")
            .description("Total number of authentication requests (login, register, validate, refresh)")
            .tag("service", "session-service")
            .register(meterRegistry);
}

@GetMapping("/authorize")
public ResponseEntity<Void> authorize(@RequestHeader("authorization") String authorization)
        throws InvalidKeySpecException, NoSuchAlgorithmException, EntityNotFoundException, RoleNotFoundException {
    authRequestsCounter.increment();  // <-- счётчик
    String jwtToken = sessionService.authorize(authorization);
    return ResponseEntity.ok().header("Authorization", "Bearer " + jwtToken).header("Access-Control-Expose-Headers", "authorization").build();
}
```
3.Добавить логи приложения с помощью Loki.

![mon](images/loki_conf_1.3.png)

4.Создать новый стек для Docker Swarm из сервисов с Prometheus Server, Loki, node_exporter, blackbox_exporter, cAdvisor. Проверить получение метрик на порту 9090 через браузер.

![mon](images/prometheus_1.4.1.png)
![mon](images/prometheus_1.4.2.png)
![mon](images/prometheus_1.4.3.png)

## Part 2. Визуализация

1.Развернуть grafana как новый сервис в стеке мониторинга.

![mon](images/grafana_2.1.png)
![mon](images/grafana_2.1.1.png)
2.Добавить в Grafana дашборд со следующими метриками:

- количество нод;
![mon](images/кол-во_нод.png)

- количество контейнеров;
![mon](images/кол-во_конт.png)

- количество стеков;
![mon](images/кол-во_стеков.png)

- использование CPU по сервисам;
![mon](images/cpu_app.png)
![mon](images/cpu_monitoring.png)

- использование CPU по ядрам и узлам;
![mon](images/cpu_по_ядрам.png)
![mon](images/cpu_по_узлам.png)

- затраченная RAM;
![mon](images/затраченная_ram.png)

- доступная и занятая память;
![mon](images/доступ_память.png)
![mon](images/занятая_память.png)

- количество CPU;
![mon](images/кол-во_cpu.png)

- доступность google.com;
![mon](images/доступ_google.png)

- количество отправленных сообщений в rabbitmq;
![mon](images/отпр_rabbit.png)

- количество обработанных сообщений в rabbitmq;
![mon](images/обр_rabbit.png)

- количество бронирований;
![mon](images/кол-во_брон.png)

- количество полученных запросов на gateway;
![mon](images/зап_на_gateway.png)

- количество полученных запросов на авторизацию пользователей;
![mon](images/зап_на_автор.png)

- логи приложения.
![mon](images/логи.png)

## Part 3. Отслеживание критических событий

1.Развернуть Alert Manager как новый сервис в стеке монтиторинга.
![mon](images/monitoring_alertmanager.png)

2.Добавить следующие критические события:
- доступная память меньше 100 Мб;
- затраченная RAM больше 1 Гб;
- использование CPU по сервису превышает 10%.
![mon](images/alerts_config.png)

3.Настроить получение оповещений через личные email и Телеграм.
![mon](images/config_alertmanager.png)
![mon](images/Stress-ng.png)
![mon](images/Low_free_memory.png)
![mon](images/High_cpu.png)
![mon](images/High_ram.png)


