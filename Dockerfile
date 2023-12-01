FROM denoland/deno:1.38.4

WORKDIR config

COPY . .

CMD ["bash"]
