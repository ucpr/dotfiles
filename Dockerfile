FROM denoland/deno:1.44.2

WORKDIR config

COPY . .

CMD ["bash"]
