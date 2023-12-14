FROM denoland/deno:1.39.0

WORKDIR config

COPY . .

CMD ["bash"]
