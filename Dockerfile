FROM denoland/deno:2.2.11

WORKDIR config

COPY . .

CMD ["bash"]
