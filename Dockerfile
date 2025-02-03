FROM denoland/deno:2.1.9

WORKDIR config

COPY . .

CMD ["bash"]
