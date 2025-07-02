FROM denoland/deno:2.4.0

WORKDIR config

COPY . .

CMD ["bash"]
