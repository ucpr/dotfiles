FROM denoland/deno:2.2.1

WORKDIR config

COPY . .

CMD ["bash"]
