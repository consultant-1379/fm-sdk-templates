ARG ERIC_ENM_FMSDK_IMAGE_NAME=eric-enm-fmsdk
ARG ERIC_ENM_FMSDK_IMAGE_REPO=<REPLACE-REPO>
ARG ERIC_ENM_FMSDK_IMAGE_TAG=1.29.0-30

FROM ${ERIC_ENM_FMSDK_IMAGE_REPO}/${ERIC_ENM_FMSDK_IMAGE_NAME}:${ERIC_ENM_FMSDK_IMAGE_TAG}

RUN /bin/mkdir -p /ericsson/credm/data/xmlfiles && \
    /bin/chown -R jboss_user:jboss /ericsson/credm/data/xmlfiles && \
    /bin/chmod -R 755 /ericsson/credm/data/xmlfiles

ENV ARCHETYPE_RPMS /var/tmp/rpms

RUN mkdir -p ${ARCHETYPE_RPMS}

COPY image_content/*.rpm ${ARCHETYPE_RPMS}/

RUN cd ${ARCHETYPE_RPMS} && if ls *.rpm > /dev/null 2>&1; then zypper --no-gpg-checks --non-interactive install *.rpm ;fi

RUN cd ${ARCHETYPE_RPMS} && rm -rf *.rpm

##################################################################
# Adding Trap-Forwarder's envvars to the JBOSS System properties #
##################################################################
RUN echo 'XX_OPTIONS="$XX_OPTIONS -Dsvc_FM_vip_fwd_ipaddress=$FM_VIP_FWD_ADDRESS"' >> /ericsson/3pp/jboss/app-server.conf && \
    echo 'XX_OPTIONS="$XX_OPTIONS -Dsvc_FM_vip_fwd_ip6address=$FM_VIP_FWD_IPV6ADDRESS"' >> /ericsson/3pp/jboss/app-server.conf

EXPOSE 22 161 162 443 6513 8080 8099 9600 12987 25161 55181 55511 55571 50691 53689 52679 58170 58171 58172 50558 56231 56234 54402 54502 55502

