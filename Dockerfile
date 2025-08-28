# Use official Tomcat base image
FROM tomcat:10.1.12-jdk17

# Remove default webapps to avoid clutter
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your JSP project into Tomcat's webapps folder
COPY . /usr/local/tomcat/webapps/ROOT

# Ensure WEB-INF/lib permissions and copy required libraries
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/lib && \
    chmod -R 755 /usr/local/tomcat/webapps/ROOT/WEB-INF/lib && \
    cp /usr/local/tomcat/webapps/ROOT/lib/*.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Set the Hugging Face token as an environment variable
# Replace 'your-huggingface-token' with your actual token or pass it at runtime
ENV HUGGINGFACE_TOKEN= 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

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
