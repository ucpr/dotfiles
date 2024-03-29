FROM denoland/deno:1.42.0

WORKDIR config

COPY . .

CMD ["bash"]
