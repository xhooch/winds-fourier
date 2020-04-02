FROM elixir:alpine

ENV HOME /opt/mill/fourier
WORKDIR $HOME

ENV MIX_ENV prod

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.* ./

COPY . .
COPY docker/startup.sh /root/startup.sh

RUN mix deps.get
RUN mix compile && \
    chmod +x /root/startup.sh

CMD /root/startup.sh
