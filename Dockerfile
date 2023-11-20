FROM denoland/deno:1.38.2

WORKDIR config

COPY . .

CMD ["bash"]
