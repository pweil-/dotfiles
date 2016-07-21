#!/bin/bash
docker build -t pweil/non-root ./non-root
docker build -t pweil/nouser ./nouser
docker build -t pweil/rootuid ./rootuid
docker build -t pweil/rootuser ./rootuser

