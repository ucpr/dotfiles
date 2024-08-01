FROM denoland/deno:1.45.5

WORKDIR config

COPY . .

CMD ["bash"]
