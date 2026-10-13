#include <fcgi_stdio.h>
#include <stdlib.h>

int main() {
    while (FCGI_Accept() >= 0) {

        printf("Content-type: text/html\r\n");
        printf("\r\n");
        
        printf("<html>\r\n");
        printf("<head><title>Hello, World!</title></head>\r\n");
        printf("<body>\r\n");
        printf("<h1>Hello, World!</h1>\r\n");
        printf("<p>FastCGI server works!</p>\r\n");
        printf("</body>\r\n");
        printf("</html>\r\n");
    }
    
    return 0;
}
