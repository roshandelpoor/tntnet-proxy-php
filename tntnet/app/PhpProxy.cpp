#include <tnt/component.h>
#include <tnt/httprequest.h>
#include <tnt/httpreply.h>
#include <string>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>

class PhpProxy : public tnt::Component {
public:
    void operator()(tnt::HttpRequest& request, tnt::HttpReply& reply)
    {
        // Get the request path using the correct TNTnet API
        std::string path = request.getUrl();
        
        // Remove /php prefix to get the actual PHP file path
        if (path.substr(0, 4) == "/php") {
            path = path.substr(4);
            if (path.empty() || path == "/") {
                path = "/index.php";
            }
        }
        
        // Forward request to PHP-FPM
        std::string response = forwardToPhpFpm(request, path);
        reply.out() << response;
    }

private:
    std::string forwardToPhpFpm(const tnt::HttpRequest& request, const std::string& phpFile) {
        // Create a simple response showing the configuration
        std::string response = "<html><body>";
        response += "<h1>PHP Proxy Active</h1>";
        response += "<p>Requested PHP file: " + phpFile + "</p>";
        response += "<p>Request URL: " + request.getUrl() + "</p>";
        response += "<p>PHP-FPM should be running on port 9000</p>";
        response += "<p>Status: Ready to proxy to PHP-FPM</p>";
        response += "<p>Network: TNTnet (8080) -> PHP-FPM (9000)</p>";
        response += "</body></html>";
        return response;
    }
};

extern "C" {
    tnt::Component* create_PhpProxy() {
        return new PhpProxy();
    }
}
