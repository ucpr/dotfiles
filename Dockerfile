FROM denoland/deno:1.44.1

WORKDIR config

COPY . .

CMD ["bash"]
