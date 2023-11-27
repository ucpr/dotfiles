FROM denoland/deno:1.38.3

WORKDIR config

COPY . .

CMD ["bash"]
