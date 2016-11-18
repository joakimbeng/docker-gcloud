FROM docker

ARG GCLOUD_SDK_VERSION

ENV GCLOUD_SDK_VERSION=${GCLOUD_SDK_VERSION:-135.0.0}
ENV GCLOUD_SDK_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz

# install curl and gcloud
RUN apk add --no-cache bash curl openssl python \
 && mkdir /opt && cd /opt \
 && wget -q -O - $GCLOUD_SDK_URL |tar zxf - \
 && /bin/bash -l -c "echo Y | /opt/google-cloud-sdk/install.sh && exit" \
 && /bin/bash -l -c "source /root/.bashrc && echo Y | gcloud components install kubectl && exit" \
 && /bin/bash -l -c "source /root/.bashrc && echo Y | gcloud components install docker-credential-gcr && exit" \
 && rm -rf /opt/google-cloud-sdk/.install/.backup

ENTRYPOINT ["/bin/bash", "-l", "-c", "/opt/google-cloud-sdk/bin/gcloud"]

