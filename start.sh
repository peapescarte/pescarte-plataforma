#!/bin/sh

bin/fuschia eval "Fuschia.Release.migrate" && \
  bin/fuschia start
