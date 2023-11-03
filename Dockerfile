FROM denoland/deno:1.38.0

WORKDIR config

COPY . .

CMD ["bash"]
