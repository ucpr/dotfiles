FROM denoland/deno:2.9.0

WORKDIR config

COPY . .

CMD ["bash"]
