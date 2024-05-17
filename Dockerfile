FROM denoland/deno:1.43.4

WORKDIR config

COPY . .

CMD ["bash"]
