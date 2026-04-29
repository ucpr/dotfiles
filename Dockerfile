FROM denoland/deno:2.7.14

WORKDIR config

COPY . .

CMD ["bash"]
