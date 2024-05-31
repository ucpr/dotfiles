FROM denoland/deno:1.44.0

WORKDIR config

COPY . .

CMD ["bash"]
