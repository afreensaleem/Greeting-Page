# Use official Tomcat base image
FROM tomcat:10.1.12-jdk17

# Remove default webapps to avoid clutter
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your JSP project into Tomcat's webapps folder
# Assuming your project folder is named Greeting-Page
COPY . /usr/local/tomcat/webapps/ROOT

# Copy org.json library to WEB-INF/lib
COPY json-20240303.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# Expose Tomcat default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
