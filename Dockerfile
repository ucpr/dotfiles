FROM denoland/deno:1.43.3

WORKDIR config

COPY . .

CMD ["bash"]
