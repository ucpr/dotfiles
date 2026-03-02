FROM denoland/deno:2.7.1

WORKDIR config

COPY . .

CMD ["bash"]
