CC = gcc
CFLAGS = -Wall -Wextra -Werror
TARGET = DO
SOURCES = main.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $^ -o $@

tests: $(TARGET)
	@echo "Running integration tests..."
	@FAILED=0; \
	./$(TARGET) 1 | grep -q "Learning to Linux" || { echo "test 1 failed"; FAILED=1; }; \
	./$(TARGET) 2 | grep -q "Learning to work with Network" || { echo "test 2 failed"; FAILED=1; }; \
	./$(TARGET) 3 | grep -q "Learning to Monitoring" || { echo "test 3 failed"; FAILED=1; }; \
	./$(TARGET) 4 | grep -q "Learning to extra Monitoring" || { echo "test 4 failed"; FAILED=1; }; \
	./$(TARGET) 5 | grep -q "Learning to Docker" || { echo "test 5 failed"; FAILED=1; }; \
	./$(TARGET) 6 | grep -q "Learning to CI/CD" || { echo "test 6 failed"; FAILED=1; }; \
	./$(TARGET) 10 | grep -q "Bad number!" || { echo "test invalid failed"; FAILED=1; }; \
	./$(TARGET) | grep -q "Bad number of arguments!" || { echo "test no args failed"; FAILED=1; }; \
	if [ $$FAILED -eq 1 ]; then \
		echo "Some tests failed!"; \
		exit 1; \
	else \
		echo "All tests passed!"; \
	fi

clean:
	rm -rf $(TARGET)

.PHONY: all clean tests
