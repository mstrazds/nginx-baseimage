FROM phusion/baseimage:0.10.1

# Phusion setup
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Set terminal to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Nginx Installation
RUN apt-get update -y && apt-get install -y wget .build-essential python-software-properties git-core vim nano
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update -y && apt-get upgrade -y && apt-get install -q -y zip unzip nginx-full ntp

# Create new symlink to UTC timezone for localtime
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Add build script
RUN mkdir -p /root/setup
ADD .build/setup.sh /root/setup/setup.sh
RUN chmod +x /root/setup/setup.sh
RUN (cd /root/setup/; /root/setup/setup.sh)

# Copy files from repo
ADD .build/default /etc/nginx/sites-available/default
ADD .build/nginx.conf /etc/nginx/nginx.conf
ADD .build/.bashrc /root/.bashrc

# Add startup scripts for services
ADD .build/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

# Set WWW public folder
RUN mkdir -p /var/www/public
ADD www/index.html /var/www/public/index.html

RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www

# Set terminal environment
ENV TERM=xterm

# Port and settings
EXPOSE 80

# Cleanup apt and lists
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
