FROM denoland/deno:2.2.9

WORKDIR config

COPY . .

CMD ["bash"]
