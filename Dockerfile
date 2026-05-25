FROM denoland/deno:2.8.0

WORKDIR config

COPY . .

CMD ["bash"]
