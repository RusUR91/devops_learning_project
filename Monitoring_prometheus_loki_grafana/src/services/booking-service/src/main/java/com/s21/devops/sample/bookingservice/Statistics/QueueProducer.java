package com.s21.devops.sample.bookingservice.Statistics;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.s21.devops.sample.bookingservice.Communication.BookingStatisticsMessage;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

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