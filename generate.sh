#!/bin/sh


bundle exec grpc_tools_ruby_protoc --ruby_out=./lib --grpc_out=./lib -I ./nodeapi nodeapi.proto

bundle exec grpc_tools_ruby_protoc --ruby_out=./lib --grpc_out=./lib -I ./api synerex.proto

bundle exec grpc_tools_ruby_protoc --ruby_out=./lib --grpc_out=./lib -I ./proto/fleet fleet.proto


