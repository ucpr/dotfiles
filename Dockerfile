FROM denoland/deno:2.8.1

WORKDIR config

COPY . .

CMD ["bash"]
