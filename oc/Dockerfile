FROM gdk
RUN  asdf global ruby 2.7.5 \
  && asdf global golang 1.17.2 \
  && asdf global nodejs 14.17.5 \
  && asdf global postgres 12.9

RUN asdf install golang 1.17.1

RUN gdk init
COPY --chown=gdk oc/startup.sh .
CMD bash /home/gdk/startup.sh; bash
#ENTRYPOINT ["/usr/bin/bash"]

