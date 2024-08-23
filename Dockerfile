FROM denoland/deno:1.46.1

WORKDIR config

COPY . .

CMD ["bash"]
