FROM denoland/deno:1.38.1

WORKDIR config

COPY . .

CMD ["bash"]
