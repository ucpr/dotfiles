FROM denoland/deno:2.6.0

WORKDIR config

COPY . .

CMD ["bash"]
