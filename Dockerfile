FROM debian-base:latest

RUN apt-get update && apt-get install -y \
    tntnet \
    && rm -rf /var/lib/apt/lists/*

# Create tntnet user and group
RUN groupadd -r tntnet && useradd -r -g tntnet tntnet

WORKDIR /app
COPY tntnet/tntnet.xml /app/tntnet.xml
COPY tntnet/app/ /app/

# Compile both components
RUN echo "Compiling Hello.ecpp..." && \
    ecppc Hello.ecpp && \
    echo "Compiling Hello.cpp to Hello.so..." && \
    g++ -fPIC -shared Hello.cpp -o Hello.so $(pkg-config --cflags --libs tntnet cxxtools) -ldl -lpthread && \
    echo "Compiling PhpProxy.cpp to PhpProxy.so..." && \
    g++ -fPIC -shared PhpProxy.cpp -o PhpProxy.so $(pkg-config --cflags --libs tntnet cxxtools) -ldl -lpthread && \
    echo "Checking if components were created..." && \
    ls -la *.so

# Change ownership of the app directory
RUN chown -R tntnet:tntnet /app

# Debug: show the contents and permissions
RUN echo "=== App directory contents ===" && \
    ls -la /app && \
    echo "=== tntnet.xml contents ===" && \
    cat /app/tntnet.xml && \
    echo "=== Component files ===" && \
    ls -la /app/*.so

USER tntnet

# Expose the port
EXPOSE 8080

# Healthcheck to ensure the service is responding on the HTTP port
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -q --spider --no-hsts http://127.0.0.1:8080/ || exit 1

# Run TNTnet with the configuration file
CMD ["tntnet", "-c", "/app/tntnet.xml"]


