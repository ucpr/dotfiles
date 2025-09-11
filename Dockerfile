FROM denoland/deno:2.5.0

WORKDIR config

COPY . .

CMD ["bash"]
