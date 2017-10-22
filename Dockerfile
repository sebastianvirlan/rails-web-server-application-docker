ARG RUBY_V=latest
FROM ruby:${RUBY_V}
RUN echo "Using ruby version $(ruby -v)"

ARG RAILS_V
WORKDIR /usr/src/app/

RUN apt-get update && apt-get install nodejs nano htop -y

RUN gem install bundle
RUN gem install shutup
RUN gem install rails ${RAILS_V:+-v $RAILS_V}
RUN rails new .

RUN echo "Using rails version $(rails -v)"

ADD ./src/gems /home/
RUN cat /home/gems >> Gemfile
RUN cat Gemfile
RUN bundle install

ADD ./src/cmd.sh /home/
RUN chmod +x /home/cmd.sh

ADD ./src/on_build.sh /home/
RUN chmod +x /home/on_build.sh && /home/on_build.sh

ADD ./src/on_run.sh /home/
RUN chmod +x /home/on_run.sh

EXPOSE 3000

CMD ["/home/cmd.sh"]