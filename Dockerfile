FROM denoland/deno:1.10.3

WORKDIR config

COPY . .

CMD ["bash"]
