FROM denoland/deno:2.2.0

WORKDIR config

COPY . .

CMD ["bash"]
