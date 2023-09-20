# Use the official Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    mysql-client \
    libapache2-mod-perl2 \
    mysql-server \
    libmysqlclient-dev \
    php \
    libapache2-mod-php \
    perl \
    libxml-simple-perl \
    libdbi-perl \
    libnet-ip-perl \
    libarchive-zip-perl \
    make \
    build-essential \
    php-pclzip \
    libdbd-mysql-perl \
    libnet-ip-perl \
    libxml-simple-perl \
    php-soap \
    php-zip \
    php-mysql \
    php-gd \
    php-curl \
    php-mbstring \
    php-xml

# Install Perl modules using CPAN
RUN apt-get install -y cpanminus && \
    cpanm XML::Simple Compress::Zlib DBI DBD::mysql Apache::DBI Net::IP Mojolicious::Lite Plack::Handler Archive::Zip YAML XML::Entities

# Copy the extracted files from the local directory into the Docker image
COPY . /app/

# Navigate to the directory containing the files
WORKDIR /app
RUN cd Switch-2.17/ && \
    perl Makefile.PL &&\
    make &&\
    make test &&\
    make install &&\
    cd ..

# Download and install OCS Server
RUN apt-get install -y wget
RUN wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.11.1/OCSNG_UNIX_SERVER-2.11.1.tar.gz 
RUN tar -xvzf OCSNG_UNIX_SERVER-2.11.1.tar.gz 
RUN cd OCSNG_UNIX_SERVER-2.11.1/ && sh setup.sh

# Enable Apache configuration for OCS Server
RUN a2enconf ocsinventory-reports && a2enconf z-ocsinventory-server.conf

# Restart Apache
RUN service apache2 restart
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Expose port 80 (HTTP)
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]

