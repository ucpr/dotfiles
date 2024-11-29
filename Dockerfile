FROM denoland/deno:2.1.2

WORKDIR config

COPY . .

CMD ["bash"]
