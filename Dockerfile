FROM ubuntu as build-env

RUN apt update -y && apt install -y android-sdk-build-tools \
    snapd \
    default-jdk
WORKDIR /tmp/
RUN apt install wget unzip zip xz-utils git curl -y
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.3.6-stable.tar.xz && \
     tar xf flutter_linux_3.3.6-stable.tar.xz -C /opt/ && \
     rm -f /tmp/flutter_linux_3.3.6-stable.tar.xz

ENV PATH="$PATH:/opt/flutter/bin"


RUN wget https://storage.googleapis.com/dart-archive/channels/beta/release/2.18.0/linux_packages/dart_2.18.0-1_amd64.deb && \
    dpkg -i dart_2.18.0-1_amd64.deb && \
    rm -rf dart_2.18.0-1_amd64.deb

ENV PATH="$PATH:/usr/lib/dart/bin"


RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt update -y && \
    apt install google-chrome-stable -y

ENV PATH $CHROMEDRIVER_DIR:$PATH

WORKDIR /app
COPY . .
RUN git config --global --add safe.directory /opt/flutter

# RUN flutter clean
# RUN flutter packages get
# RUN flutter packages upgrade
RUN flutter pub get
RUN flutter build web --dart-define=ENVIRONMENT=DEV
#RUN flutter config --enable-web

FROM nginx
COPY --from=build-env /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]