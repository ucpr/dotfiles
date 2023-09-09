FROM denoland/deno:1.36.4

WORKDIR config

COPY . .

CMD ["bash"]
