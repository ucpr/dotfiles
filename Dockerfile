FROM denoland/deno:1.39.1

WORKDIR config

COPY . .

CMD ["bash"]
