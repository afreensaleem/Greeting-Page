# Use official Tomcat base image
FROM tomcat:10.1.12-jdk17

# Remove default webapps to avoid clutter
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your JSP project into Tomcat's webapps folder
# Assuming your project folder is named Greeting-Page
COPY Greeting-Page /usr/local/tomcat/webapps/ROOT

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
