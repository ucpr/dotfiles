FROM denoland/deno:1.44.4

WORKDIR config

COPY . .

CMD ["bash"]
