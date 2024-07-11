FROM denoland/deno:1.45.0

WORKDIR config

COPY . .

CMD ["bash"]
