FROM denoland/deno:1.40.2

WORKDIR config

COPY . .

CMD ["bash"]
