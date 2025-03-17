FROM denoland/deno:2.2.4

WORKDIR config

COPY . .

CMD ["bash"]
