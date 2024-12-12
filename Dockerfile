FROM denoland/deno:2.1.4

WORKDIR config

COPY . .

CMD ["bash"]
