FROM denoland/deno:1.46.2

WORKDIR config

COPY . .

CMD ["bash"]
